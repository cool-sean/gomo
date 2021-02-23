const is = (condition, trueFn, falseFn) => {
  return condition ? trueFn : falseFn;
};

const pauseIfP = async (conditionFn, options = {}) => {
  let { errorMessage, maxCount, delay } = options;

  if (typeof delay        !== 'number') delay = 1000;
  if (typeof maxCount     !== 'number') maxCount = 10;
  if (typeof errorMessage !== 'string') errorMessage = 'The condition you paused on timed out.';

  if (maxCount === 0) throw Error(errorMessage);

  let condition;

  do {

    condition = conditionFn()

    if (typeof condition.then === 'function') {
      condition = await condition;
    }

    mobile.pause(delay);

    maxCount--;

  } while (condition !== true || maxCount > 0)
};

const pauseIf = (conditionFn, options = {}) => {
  let { errorMessage, maxCount, delay } = options;

  if (typeof delay        !== 'number') delay = 1000;
  if (typeof maxCount     !== 'number') maxCount = 10;
  if (typeof errorMessage !== 'string') errorMessage = 'The condition you paused on timed out.';

  if (maxCount === 0) throw Error(errorMessage);

  if (conditionFn()) {
    mobile.pause(delay);
    pauseIf(conditionFn, { maxCount: maxCount - 1, delay, errorMessage });
  }
};

const doTillTrue = (doFn, conditionFn, options = {}) => {
  let { errorMessage, maxCount, delay } = options;

  if (typeof delay        !== 'number') delay = 1000;
  if (typeof maxCount     !== 'number') maxCount = 10;
  if (typeof errorMessage !== 'string') errorMessage = 'Maximum dos reached.';

  if (maxCount === 0) throw Error(errorMessage);

  if (!conditionFn()) {
    doFn();
    mobile.pause(delay);
    doTillTrue(doFn, conditionFn, { maxCount: maxCount - 1, delay, errorMessage });
  }
};

const getFileSizeInKb = (filepath) => {
  try {
    const stats = fs.statSync(filepath);
    return Math.round(stats.size / 1000);
  } catch (e) {
    return NaN;
  }
};

module.exports = {
  doTillTrue,
  getFileSizeInKb,
  pauseIfP,
  pauseIf,
  is,
};
