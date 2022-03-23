import 'package:flutter/material.dart';

// import '../errors/error_handler.dart';
import 'bloc.dart';

abstract class AStatefulWB<S extends StatefulWidget, B extends ABloc>
    extends State<S> {
  @protected
  B bloc;

  @protected
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    // disposableFunctions.add(bloc.dispose);
    // bloc.states$.listen((_) {}, onError: onError);
  }

  @protected
  @override
  @mustCallSuper
  void dispose() {
    // disposable();
    super.dispose();
  }

  // @protected
  // @mustCallSuper
  // void onError(Object error) => ErrorHandler.instance.handle(error, context: context);
}

abstract class AStatefulWL<W extends StatefulWidget, L> extends State<W> {
  @protected
  L l10n;

  @protected
  @override
  @mustCallSuper
  void dispose() {
    // disposable();
    super.dispose();
  }

  @protected
  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n ??= Localizations.of<L>(context, L);
  }
}

abstract class AStatefulWBL<W extends StatefulWidget, B extends ABloc, L>
    extends AStatefulWB<W, B> {
  @protected
  L l10n;

  @protected
  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n ??= Localizations.of<L>(context, L);
  }
}
