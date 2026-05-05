package a0.term;
import android.app.*;
import android.content.*;
import android.os.*;
import android.view.*;
import android.view.inputmethod.*;
import android.widget.*;
import java.io.*;
import java.lang.*;

public class A0 extends Activity {
    ScrollView scroll;
    TextView output;
    EditText input;
    java.lang.Process shell;
    OutputStream stdin;

    @Override public void onCreate(Bundle b) {
        super.onCreate(b);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0A0A0A);

        output = new TextView(this);
        output.setTextColor(0xFF00FF00);
        output.setTextSize(12);
        output.setTypeface(android.graphics.Typeface.MONOSPACE);
        output.setPadding(8,8,8,4);
        scroll = new ScrollView(this);
        scroll.addView(output);
        root.addView(scroll, new LinearLayout.LayoutParams(-1,0,1f));

        input = new EditText(this);
        input.setTextColor(0xFF00FF00);
        input.setBackgroundColor(0xFF111111);
        input.setTextSize(12);
        input.setTypeface(android.graphics.Typeface.MONOSPACE);
        input.setHint("$");
        input.setHintTextColor(0xFF005500);
        input.setSingleLine(true);
        input.setOnEditorActionListener((v,act,ev)->{runCmd();return true;});
        root.addView(input);
        setContentView(root);

        startService(new Intent(this, A0Service.class));
        startShell();
    }

    void startShell() {
        try {
            shell = Runtime.getRuntime().exec(new String[]{"/system/bin/sh","-l"});
            stdin = shell.getOutputStream();
            new Thread(()->{
                try { BufferedReader r=new BufferedReader(new InputStreamReader(shell.getInputStream()));
                    String l; while((l=r.readLine())!=null) append(l);
                } catch(Exception e){}
            }).start();
            new Thread(()->{
                try { BufferedReader r=new BufferedReader(new InputStreamReader(shell.getErrorStream()));
                    String l; while((l=r.readLine())!=null) append(l);
                } catch(Exception e){}
            }).start();
            append("[a0] terminal ready");
        } catch(Exception e) { append("error: "+e.getMessage()); }
    }

    void runCmd() {
        String cmd=input.getText().toString();
        input.setText("");
        append("$ "+cmd);
        try { stdin.write((cmd+"\n").getBytes()); stdin.flush(); }
        catch(Exception e) { append("err: "+e.getMessage()); }
    }

    void append(String t) {
        runOnUiThread(()->{ output.append(t+"\n"); scroll.post(()->scroll.fullScroll(ScrollView.FOCUS_DOWN)); });
    }
}
