//
//  AuthProvider.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 20/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void;

/*Estrutura responsavel por nomear os erros*/
struct LoginErrorCode {
    static let INVALID_EMAIL = "Endereço de e-mail inválido, forneça um endereço de e-mail real";
    static let WRONG_PASSWORD = "Senha incorreta, digite a senha correta";
    static let PROBLEM_CONNECTING = "Problema de conexão ao banco de dados, tente mais tarde";
    static let USER_NOT_FOUND = "Usuário não encontrado, registre-se";
    static let EMAIL_ALREADY_IN_USE = "E-mail já em uso, use outro e-mail";
    static let WEAK_PASSWORD = "A senha deve ter no mínimo 6 caracteres";
}

class AuthProvider {
    
    
    /*Instanciar a classe*/
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance;
    }
    
    var userName = "";
    
    /*
     Função responsavel por realizar o login ao Firebase
     */
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            if error != nil {
               self.handleErrors(err: error as! NSError, loginHandler: loginHandler);
            } else {
                loginHandler?(nil);
            }
        }
    }
    
    /*
     Função responsavel por realizar o cadastro no Firebase
     */
    func signUp(withEmail: String, password: String,name: String, course: String, matricula:String, monitor: String,  loginHandler: LoginHandler?) {
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler);
            } else {
                loginHandler?(nil);
                if user?.uid != nil {
                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: password, name: name, course: course, matricula: matricula, monitor: monitor);
                   self.login(withEmail: withEmail, password: password, loginHandler: loginHandler);
                }
            }
        });
    }
    
    
    
    /*
     Função responsavel por redefinir senha
     */
    
    func resetPassword(withEmail: String,loginHandler: LoginHandler?) {
         Auth.auth().sendPasswordReset(withEmail: withEmail) { (error) in
            if error != nil {
                print(error?.localizedDescription)
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler);
            } else {
                loginHandler?(nil);
            }
        }
    }
    
    
    
    /*
     Função responsavel por realizar o logout do sistema
     */

    func logOut() -> Bool {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut();
                return true;
            } catch {
                return false;
            }
        }
        return true;
    }
    
    
    /*
     Função responsavel por verificar se o usuario está logado no sistema ainda.
     */
    
    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true;
        }
        return false;
    }
    

    /*
     Função retorna o id do usuario
     */
    func userID() -> String {
        return Auth.auth().currentUser!.uid;
    }
    
    /*
     Função retorna o id do parceiro
     */
//
//    func idParceiro() -> String? {
//        return paraID == FIRAuth.auth()?.currentUser?.uid ? meuID : paraID
//    }
    
    
    
    

    
    
    /*
        Função responsavel por mostrar os erros
     */
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        if let errCode = AuthErrorCode(rawValue: err.code) {
            switch errCode {
                case .wrongPassword:
                    loginHandler?(LoginErrorCode.WRONG_PASSWORD);
                    break;
                
                case .invalidEmail:
                    loginHandler?(LoginErrorCode.INVALID_EMAIL);
                    break;
                
                case .userNotFound:
                    loginHandler?(LoginErrorCode.USER_NOT_FOUND);
                    break;
                
                case .emailAlreadyInUse:
                    loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                    break;
                
                case .weakPassword:
                    loginHandler?(LoginErrorCode.WEAK_PASSWORD);
                    break;
                
                default:
                    loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                    break;
            }
        }
    }
}












































