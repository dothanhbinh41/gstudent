//<<<<<<< HEAD
//package vn.edu.edutalk.coach.services
//
//import android.app.NotificationManager
//import android.app.PendingIntent
//import android.content.Context
//import android.content.Intent
//import android.media.RingtoneManager
//import android.net.Uri
//import android.util.Log
//import androidx.core.app.NotificationCompat
//import com.google.firebase.messaging.FirebaseMessagingService
//import com.google.firebase.messaging.RemoteMessage
//import vn.edu.edutalk.coach.MainActivity
//import vn.edu.edutalk.coach.R
//
//
//class MyFirebaseMessagingService : FirebaseMessagingService() {
//    override fun onMessageReceived(remoteMessage: RemoteMessage) {
//        //Displaying data in log
//        //It is optional
////        var gson = Gson()
////        var jsonString = gson.toJson(remoteMessage)
//
////        Log.d(TAG,  jsonString)
//        var a = remoteMessage.data;
//        a.values.forEach {
//            Log.d(TAG,  it)
//        }
//        if(remoteMessage.notification != null){
//            sendNotification(remoteMessage.notification?.title,remoteMessage.notification?.body)
//
//        }else{
//            if(remoteMessage.data != null && remoteMessage.data.values.isNotEmpty() ){
//                sendNotification(remoteMessage.data.values.first(),remoteMessage.data.values.last())
//            }
//        }
//
//    }
//
//    //This method is only generating push notification
//    //It is same as we did in earlier posts
//    private fun sendNotification(title: String?,messageBody: String?) {
//        val intent = Intent(this, MainActivity::class.java)
//        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
//        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent,
//                PendingIntent.FLAG_ONE_SHOT)
//        val defaultSoundUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
//        val notificationBuilder: NotificationCompat.Builder = NotificationCompat.Builder(this)
//                .setSmallIcon(R.mipmap.ic_app_ecoach)
//                .setContentTitle(title)
//                .setContentText(messageBody)
//                .setAutoCancel(true)
//                .setSound(defaultSoundUri)
//                .setContentIntent(pendingIntent)
//        val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//        notificationManager.notify(0, notificationBuilder.build())
//    }
//
//    companion object {
//        private const val TAG = "MyFirebaseMsgService"
//    }
//
//    override fun onNewToken(p0: String) {
//        super.onNewToken(p0)
//        Log.d("FCM_token", p0!!)
//    }
//
//
//}
//=======
////package vn.edu.edutalk.coach.services
////
////import android.app.NotificationManager
////import android.app.PendingIntent
////import android.content.Context
////import android.content.Intent
////import android.media.RingtoneManager
////import android.net.Uri
////import android.util.Log
////import androidx.core.app.NotificationCompat
////import vn.edu.edutalk.coach.MainActivity
////import com.google.firebase.messaging.FirebaseMessagingService
////import com.google.firebase.messaging.RemoteMessage
////import com.google.gson.Gson
////import vn.edu.edutalk.coach.R
////
////
////class MyFirebaseMessagingService : FirebaseMessagingService() {
////    override fun onMessageReceived(remoteMessage: RemoteMessage) {
////        //Displaying data in log
////        //It is optional
//////        var gson = Gson()
//////        var jsonString = gson.toJson(remoteMessage)
////
//////        Log.d(TAG,  jsonString)
////        var a = remoteMessage.data;
////        a.values.forEach {
////            Log.d(TAG,  it)
////        }
////        if(remoteMessage.notification != null){
////            sendNotification(remoteMessage.notification?.title,remoteMessage.notification?.body)
////
////        }else{
////            if(remoteMessage.data != null && remoteMessage.data.values.isNotEmpty() ){
////                sendNotification(remoteMessage.data.values.first(),remoteMessage.data.values.last())
////            }
////        }
////
////    }
////
////    //This method is only generating push notification
////    //It is same as we did in earlier posts
////    private fun sendNotification(title: String?,messageBody: String?) {
////        val intent = Intent(this, MainActivity::class.java)
////        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
////        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent,
////                PendingIntent.FLAG_ONE_SHOT)
////        val defaultSoundUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
////        val notificationBuilder: NotificationCompat.Builder = NotificationCompat.Builder(this)
////                .setSmallIcon(R.mipmap.ic_app_ecoach)
////                .setContentTitle(title)
////                .setContentText(messageBody)
////                .setAutoCancel(true)
////                .setSound(defaultSoundUri)
////                .setContentIntent(pendingIntent)
////        val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
////        notificationManager.notify(0, notificationBuilder.build())
////    }
////
////    companion object {
////        private const val TAG = "MyFirebaseMsgService"
////    }
////
////    override fun onNewToken(p0: String) {
////        super.onNewToken(p0)
////        Log.d("FCM_token", p0!!)
////    }
////
////
////}
//>>>>>>> 418c272bb5f0e7986e4f6f35c56a3d75ebfc98f3
