package top.healingai.healing_music;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;

public class MainActivity extends FlutterActivity {
    private static final String eventChannel = "top.healingAI.brainlink/receiver";
    private static final String BCI_ACTION = "top.healingAI.brainlink_hm.BCI_DATA"; // 提取常量
    private BroadcastReceiver receiver;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), eventChannel).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @SuppressLint({"UnspecifiedRegisterReceiverFlag", "ObsoleteSdkInt"})
                    @Override
                    public void onListen(Object args, EventChannel.EventSink events) {
                        try {
                            if (receiver != null) {
                                unregisterReceiver(receiver);
                            }
                            receiver = new BroadcastReceiver() {
                                @Override
                                public void onReceive(Context context, Intent intent) {
                                    if (BCI_ACTION.equals(intent.getAction())) { // 添加action校验
                                        String bci = intent.getStringExtra("bci_data");
                                        if (bci != null) events.success("bci_"+bci);
                                        String hrv = intent.getStringExtra("hrv_data");
                                        if (hrv != null) events.success("hrv_"+hrv);
                                    }
                                }
                            };
                            IntentFilter filter = new IntentFilter(BCI_ACTION);
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                registerReceiver(receiver, filter, 
                                    Context.RECEIVER_EXPORTED); 
                            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                registerReceiver(receiver, filter);
                            }
                        } catch (Exception e) {
                            events.error("REGISTRATION_ERROR", e.getMessage(), null);
                        }
                    }

                    @Override
                    public void onCancel(Object args) {
                        try {
                            if (receiver != null) {
                                unregisterReceiver(receiver);
                                receiver = null;
                            }
                        } catch (Exception e) {
                            // 可添加日志记录
                        }
                    }
                }
        );
    }

    @Override
    protected void onDestroy() {
        try {
            if (receiver != null) {
                unregisterReceiver(receiver);
                receiver = null;
            }
        } catch (Exception e) {
            // 异常处理
        }
        super.onDestroy(); // 保持父类调用在最后
    }
}