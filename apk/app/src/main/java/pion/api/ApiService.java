package pion.api;
import android.app.*;
import android.content.*;
import android.os.*;
import java.io.*;

public class ApiService extends Service {
    private Process prootProcess;
    private static final int NOTIF_ID = 1;
    private static final String CHANNEL = "pion";
    @Override
    public void onCreate() {
        NotificationChannel ch = new NotificationChannel(CHANNEL, "PION", NotificationManager.IMPORTANCE_LOW);
        getSystemService(NotificationManager.class).createNotificationChannel(ch);
    }
    @Override
    public int onStartCommand(Intent i, int f, int sid) {
        Notification n = new Notification.Builder(this, CHANNEL)
            .setContentTitle("PION").setContentText("Agent Zero running")
            .setSmallIcon(android.R.drawable.ic_dialog_info).build();
        startForeground(NOTIF_ID, n);
        startProot();
        return START_STICKY;
    }
    private void startProot() {
        new Thread(() -> {
            try {
                ProcessBuilder pb = new ProcessBuilder("proot-distro", "login", "debian", "--",
                    "bash", "-c", "cd ~/agent-zero && source .venv/bin/activate && python3 run_ui.py");
                pb.redirectErrorStream(true);
                prootProcess = pb.start();
                prootProcess.waitFor();
            } catch (Exception e) { e.printStackTrace(); }
        }).start();
    }
    @Override public IBinder onBind(Intent i) { return null; }
    @Override public void onDestroy() { if (prootProcess != null) prootProcess.destroy(); }
}
