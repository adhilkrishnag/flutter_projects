import 'package:chat_app/src/feature/auth/bloc/auth_bloc.dart';
import 'package:chat_app/src/feature/auth/data/auth_repository_impl.dart';
import 'package:chat_app/src/feature/auth/data/firebase_auth_data_source.dart';
import 'package:chat_app/src/feature/auth/domain/sign_in.dart';
import 'package:chat_app/src/feature/auth/domain/sign_out.dart';
import 'package:chat_app/src/feature/auth/domain/sign_up.dart';
import 'package:chat_app/src/feature/chat/bloc/chat_bloc.dart';
import 'package:chat_app/src/feature/chat/data/chat_repository_impl.dart';
import 'package:chat_app/src/feature/chat/data/firebase_chat_data_source.dart';
import 'package:chat_app/src/feature/chat/domain/get_messages.dart';
import 'package:chat_app/src/feature/chat/domain/send_message.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Auth Feature
  getIt.registerSingleton<FirebaseAuthDataSource>(FirebaseAuthDataSource());
  getIt.registerSingleton<AuthRepositoryImpl>(
    AuthRepositoryImpl(firebaseAuthDataSource: getIt<FirebaseAuthDataSource>()),
  );
  getIt.registerSingleton<SignIn>(SignIn(getIt<AuthRepositoryImpl>()));
  getIt.registerSingleton<SignUp>(SignUp(getIt<AuthRepositoryImpl>()));
  getIt.registerSingleton<SignOut>(SignOut(getIt<AuthRepositoryImpl>()));
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signIn: getIt<SignIn>(),
      signUp: getIt<SignUp>(),
      signOut: getIt<SignOut>(),
    ),
  );

  // Chat Feature
  getIt.registerSingleton<FirebaseChatDataSource>(FirebaseChatDataSource());
  getIt.registerSingleton<ChatRepositoryImpl>(
    ChatRepositoryImpl(firebaseChatDataSource: getIt<FirebaseChatDataSource>()),
  );
  getIt.registerSingleton<SendMessage>(
      SendMessage(getIt<ChatRepositoryImpl>()));
  getIt.registerSingleton<GetMessages>(
      GetMessages(getIt<ChatRepositoryImpl>()));
  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(
      sendMessage: getIt<SendMessage>(),
      getMessages: getIt<GetMessages>(),
    ),
  );
}