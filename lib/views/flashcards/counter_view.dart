import 'package:flashcards_reader/bloc/counter/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: BlocProvider(
        create: (_) => CounterBloc(),
        child: const CounterView(),
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Counter', style: TextStyle(fontSize: 24.0)),
              Text('${state.counterValue}',
                  style: const TextStyle(fontSize: 36.0)),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Bob(),
                  const SizedBox(width: 16.0),
                  FloatingActionButton(
                    onPressed: () => context
                        // turn to counter bloc and add decrement counter event
                        .read<CounterBloc>()
                        .add(DecrementCounter(counterValue: 2)),
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class Bob extends StatefulWidget {
  const Bob({super.key});

  @override
  State<Bob> createState() => _BobState();
}

class _BobState extends State<Bob> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context
          // turn to counter bloc and add increment counter event
          .read<CounterBloc>()
          .add(IncrementCounter(counterValue: 2)),
      child: const Icon(Icons.add),
    );
  }
}
