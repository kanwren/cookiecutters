// Some unit tests to make sure that inferred types match up using Leibniz
// equality. If this compiles, the tests have passed. This can't catch stray
// 'any's, so watch out for those.

type Leibniz<A, B> = ((a: A) => B) & ((b: B) => A);

function id<A>(x: A): A {
    return x;
}

const idReturn = id(3);
const idResultCorrect: Leibniz<
    typeof idReturn,
    3
> = id;

