package pion.api;
import android.app.*;
import android.content.*;
import android.os.*;
import android.view.*;
import android.webkit.*;
import android.widget.*;
import java.io.*;

public class MainActivity extends Activity {
    private WebView web;
    private TextView status;
    @Override
    public void onCreate(Bundle b) {
        super.onCreate(b);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0A0A0A);
        status = new TextView(this);
        status.setText("PION starting...");
        status.setTextColor(0xFF00FF00);
        status.setTextSize(12);
        status.setPadding(8,8,8,4);
        root.addView(status);
        web = new WebView(this);
        web.getSettings().setJavaScriptEnabled(true);
        web.getSettings().setDomStorageEnabled(true);
        web.setWebViewClient(new WebViewClient());
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f);
        root.addView(web, lp);
        setContentView(root);
        startForegroundService(new Intent(this, ApiService.class));
        new Handler().postDelayed(() -> {
            web.loadUrl("http://127.0.0.1:8421");
            status.setText("PION connected");
        }, 5000);
    }
}
