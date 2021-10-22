const AuthLogoutHook = {
  mounted() {
    // Log the user out
    document.location = "/instant-sign-out";
  },
};

export default AuthLogoutHook;
