import 'package:fpdart/fpdart.dart';
import 'package:reddit_tutorial/Core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
