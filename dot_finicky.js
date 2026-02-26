module.exports = {
  defaultBrowser: { name: "Zen" },
  rewrite: [
    {
      // Redirect all urls to use https
      match: (url) => url.protocol === "http:",
      url: (url) => {
        url.protocol = "https:";
        return url;
      },
    },
  ],
  handlers: [
    {
      // Open apple.com and example.com urls in Safari
      match: ["localhost*", "*curseforge.com", "*overwolf.com"],
      browser: { name: "Google Chrome", profile: "Profile 1" },
    },
  ],
};
