import 'package:appwrite/appwrite.dart';
import 'package:new_super_jumper/auth/appwrite_contrait.dart';

Client client = Client()
    .setEndpoint(AppwriteConstants.endPoint)
    .setProject(AppwriteConstants.projectId)
    .setSelfSigned(
        status: true);

Account account = Account(client);



