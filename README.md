# dynamic_app

Dynamically change your theme  and locale 


## How to use

#### First add dynamic_app to you'r dependencies
 

``` 
dependencies:
dynamic_app: ^0.1.1
```

#### Then install it 
```
$ flutter packages get
```

#### And finaly import and use it like that 

```
import 'package:dynamic_app/dynamic_app.dart';
```

In you'r application change you'r aplication to be like this code
```
return DynamicApp(
      defaultLocale: Locale('fa'),
      defaultBrightness: Brightness.dark,
      data: (Brightness brightness) => ThemeData(
        primarySwatch: Colors.indigo,
        brightness: brightness,
      ),
      dynamicWidgetBuilder: (context,theme,locale){
        return MaterialApp(
          title: 'Flutter Demo',
          locale: locale,
          theme: theme,
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
```

And for changeing theme,brightness and locale use this code's
```
  void changeBrightness() {
    DynamicApp.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  void changeColor() {
    DynamicApp.of(context).setThemeData(
        DynamicApp.of(context).data.copyWith(
            primaryColor: Theme.of(context).primaryColor == Colors.indigo
                ? Colors.red
                : Colors.indigo)
        );
  }
  
  void changeLocale() {
    DynamicApp.of(context).setLocale("en");
  }
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.io/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
