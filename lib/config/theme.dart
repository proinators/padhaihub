// Built on
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:padhaihub/config/consts.dart';



CustomColors lightCustomColors = CustomColors(danger: lightDangerColor, landing1: lightLanding1, landing2: lightLanding2);
CustomColors darkCustomColors = CustomColors(danger: darkDangerColor, landing1: darkLanding1, landing2: darkLanding2);
ThemeData lightData = ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: brandingColor));
ThemeData darkData = ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: brandingColor, brightness: Brightness.dark));

bool useMaterial3 = true;

Map<Brightness, ThemeData> themeBuilder(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    ColorScheme lightColorScheme;
    ColorScheme darkColorScheme;

    if (lightDynamic != null && darkDynamic != null) {
      lightColorScheme = lightDynamic.harmonized();
      lightColorScheme =
          lightColorScheme.copyWith(secondary: brandingColor);
      lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

      darkColorScheme = darkDynamic.harmonized();
      darkColorScheme =
          darkColorScheme.copyWith(secondary: brandingColor);
      darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
    } else {
      // Otherwise, use fallback schemes.
      lightColorScheme = ColorScheme.fromSeed(
        seedColor: brandingColor,
      );
      darkColorScheme = ColorScheme.fromSeed(
        seedColor: brandingColor,
        brightness: Brightness.dark,
      );
    }
    return {
      Brightness.light: ThemeData(
        colorScheme: lightColorScheme,
        extensions: [lightCustomColors],
        useMaterial3: useMaterial3
      ),
      Brightness.dark: ThemeData(
        colorScheme: darkColorScheme,
        extensions: [darkCustomColors],
        useMaterial3: useMaterial3
      )
    };
}

// Unused as of now. Has issues working with the BuildContext. Will be added back
// Build a theme by harmonizing with the system accent colors
// class ThemeBuilder extends StatelessWidget {
//   final Widget Function (ThemeData lightData, ThemeData darkTheme, BuildContext context) builder;
//   const ThemeBuilder({super.key, required this.builder});
//
//   @override
//   Widget build(BuildContext context) {
//     return DynamicColorBuilder(
//         builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
//           Map<Brightness, ThemeData> themes = themeBuilder(lightDynamic, darkDynamic);
//           return builder(
//               themes[Brightness.light]!,
//               themes[Brightness.dark]!,
//             context,
//           );
//         }
//         );
//   }
// }

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
    required this.landing1,
    required this.landing2,
  });

  final Color? danger;
  final Color? landing1;
  final Color? landing2;

  @override
  CustomColors copyWith({Color? danger, Color? landing1, Color? landing2}) {
    return CustomColors(
      danger: danger ?? this.danger,
      landing1: landing1 ?? this.landing1,
      landing2: landing2 ?? this.landing2,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
      landing1: Color.lerp(landing1, other.landing1, t),
      landing2: Color.lerp(landing2, other.landing2, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
        danger: danger!.harmonizeWith(dynamic.primary),
        landing1: landing1!.harmonizeWith(dynamic.primary),
        landing2: landing2!.harmonizeWith(dynamic.primary)
    );
  }
}
