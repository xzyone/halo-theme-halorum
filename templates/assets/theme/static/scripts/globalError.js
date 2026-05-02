window.$halorumGlobalError = {
  list: [],
  callback: null,
};

window.addEventListener(
  "error",
  (event) => {
    if (typeof window.$halorumGlobalError.callback === "function") {
      window.$halorumGlobalError.callback(event);
      return;
    }

    window.$halorumGlobalError.list.push(event);
  },
  true
);
