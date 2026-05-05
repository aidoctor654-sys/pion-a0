package a0;
import android.app.*;
import android.content.*;
import android.os.*;
public class A0Service extends Service {
    static final String CH="a0";
    @Override public void onCreate(){new NotificationChannel(CH,"a0",NotificationManager.IMPORTANCE_LOW);}
    @Override public int onStartCommand(Intent i,int f,int id){
        startForeground(1,new Notification.Builder(this,CH).setContentTitle("a0").setContentText("running").setSmallIcon(android.R.drawable.ic_dialog_info).build());
        return START_STICKY;
    }
    @Override public IBinder onBind(Intent i){return null;}
}
