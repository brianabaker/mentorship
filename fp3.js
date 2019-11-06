// compose :: (b -> c) -> (a -> b) -> a -> c
const compose = f => g => x => f(g(x));

class Identity {
  // map :: Identity a ~> (a -> b) -> Identity b
  map = (fn) => {
    return Identity.of(fn(this._value));
  }

  // flatten :: Identity (Identity a) ~> () -> Identity a
  flatten = () => {
    if (this._value instanceof Identity) return this._value;

    throw new Error("Must be layered identity.");
  }

  // chain :: Identity a ~> (a -> Identity b) -> Identity b
  chain = (fn) => {
    return compose(this.flatten)(this.map)(fn);
  }

  // extract :: Identity a ~> () -> a
  extract() {
    return this._value;
  }
}

class Maybe {
  // extract :: Maybe a ~> (a) -> a
  extract(alt) {
    if (this.isNothing()) return alt;

    return this._value;
  }
}

// IO a
class IO {
  // (() -> a) -> IO a
  constructor(value) {
    this._value = value;
  }

  // of :: (() -> a) -> IO a
  static of(value) {
    new IO(value);
  }

  // map :: IO a ~> (a -> b) -> IO b
  map = (fn) => {
    return IO.of(compose(fn)(this._value));
  }

  // flatten :: IO (IO a) ~> () -> IO a
  flatten = () => {
    return this._value(); // IO a
  }

  // chain :: IO a ~> (a -> IO b) -> IO b
  chain = (fn) => {
    return compose(this.flatten)(this.map)(fn);
  }

  // extract :: IO a ~> () -> a
  extract() {
    return this._value();
  }
}

// reheat :: String -> String
const reheat = (str) => str.replace("cold", "hot");

// coldFood :: IO String
const coldFood = IO.of(() => "cold food");

// hotFood :: IO String
const hotFood = coldFood.map(reheat);

// countOs :: String -> IO Number
const countOs = (str) => {
  const value = () => str.split("").filter((letter => letter === "o").length);

  return IO.of(value);
};

// numOfOs :: IO Number
const numOfOs = hotFood.chain(countOs);

// ...

numOfOs.extract(); // Number

// :: Array String
const names = [];

// :: IO (Maybe String)
const ioOfFirstName = IO.of(() => Maybe.of(names[0]));

// :: String -> Number
const getLength = (str) => str.length;

// :: IO (Maybe Number)
const ioOfLength = ioOfFirstName.map((maybeOfStr) => maybeOfStr.map(getLength));
