import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyApp(),
    ),
  );
}

const names = {
  'Foo',
  'Bar',
  'Baz',
  'Fizz',
  'Buzz',
  'Chicken',
  'Shrimp',
};

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());

  void reset() => emit(null);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NamesCubit cubit;
  bool showResetButton = false;

  @override
  void initState() {
    super.initState();

    cubit = NamesCubit();
  }

  @override
  void dispose() {
    super.dispose();

    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My App')),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = Center(
            child: ElevatedButton(
              onPressed: () {
                cubit.pickRandomName();
                showResetButton = true;
              },
              child: const Text('Pick a random name'),
            ),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 50),
                    Text(snapshot.data ?? ''),
                    // const SizedBox(height: 50),
                    button,
                    if (showResetButton)
                      ElevatedButton(
                        onPressed: () {
                          cubit.reset();
                          setState(() {
                            showResetButton = false;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                  ],
                ),
              );
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
