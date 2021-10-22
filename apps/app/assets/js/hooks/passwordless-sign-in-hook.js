const PasswordlessSignInHook = {
  mounted() {
    this.handleEvent(
      "passwordless_sign_in",
      ({ user_base64_token, user_return_to }) => {
        let formEl = this.el.querySelector("form");
        let loadingEl = this.el.querySelector(".loading");
        let tokenInput = this.el.querySelector(
          "input[name='user[base64_token]']"
        );
        let userReturnToInput = this.el.querySelector(
          "input[name='user_return_to']"
        );

        // Set the token and submit the sign in form for the user
        if (user_base64_token != null) {
          tokenInput.value = user_base64_token;

          if (user_return_to) {
            userReturnToInput.value = user_return_to;
          }

          formEl.style.display = "none";
          loadingEl.style.display = "flex";
          formEl.submit();
        }
      }
    );
  },
};

export default PasswordlessSignInHook;
