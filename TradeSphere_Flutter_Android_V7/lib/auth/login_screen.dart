import 'package:flutter/material.dart';
import '../../services/auth_api.dart';
import '../../services/api_client.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
 final email=TextEditingController(), password=TextEditingController(); bool obscure=true, loading=false;
 @override void dispose(){email.dispose();password.dispose();super.dispose();}
 Future<void> login() async { if(email.text.trim().isEmpty||password.text.isEmpty)return; setState(()=>loading=true); try { await AuthApi().login(email.text.trim(),password.text); if(mounted) Navigator.pop(context,true); } catch(e){ if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e is ApiException?e.message:e.toString()))); } finally { if(mounted)setState(()=>loading=false); } }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Login')),body:ListView(padding:const EdgeInsets.all(22),children:[const SizedBox(height:30),const Text('Welcome back',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold)),const SizedBox(height:24),TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email',prefixIcon:Icon(Icons.email_outlined))),const SizedBox(height:14),TextField(controller:password,obscureText:obscure,decoration:InputDecoration(labelText:'Password',prefixIcon:const Icon(Icons.lock_outline),suffixIcon:IconButton(onPressed:()=>setState(()=>obscure=!obscure),icon:Icon(obscure?Icons.visibility:Icons.visibility_off)))),const SizedBox(height:22),FilledButton(onPressed:loading?null:login,child:Text(loading?'Signing in...':'Login')),const SizedBox(height:12),OutlinedButton(onPressed:loading?null:() async {final ok=await Navigator.push<bool>(context,MaterialPageRoute(builder:(_)=>const SignupScreen()));if(ok==true&&mounted)Navigator.pop(context,true);},child:const Text('Create account'))]));
}
  
