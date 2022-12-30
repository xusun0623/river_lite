package com.xusun000.river_lite_2022

import io.flutter.embedding.android.FlutterActivity
import android.os.Build;
import android.view.Window;
import android.view.WindowManager;

class MainActivity: FlutterActivity() {}

// public class MainActivity extends FlutterActivity {
//   @Override
//   protected void onCreate(Bundle savedInstanceState) {
//     super.onCreate(savedInstanceState);
//     // add these lines
//     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
//         Window window = getWindow();
//         window.setFlags(
//             WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
//             WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
//         );
//     }
//     // ...
//   }
// }
