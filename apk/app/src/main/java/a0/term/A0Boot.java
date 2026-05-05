package a0.term;
import android.content.*;
public class A0Boot extends BroadcastReceiver {
    @Override public void onReceive(Context c,Intent i){if(Intent.ACTION_BOOT_COMPLETED.equals(i.getAction()))c.startForegroundService(new Intent(c,A0Service.class));}
}
