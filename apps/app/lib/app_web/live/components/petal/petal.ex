defmodule AppWeb.Petal do
  defmacro __using__(_) do
    quote do
      alias AppWeb.Petal.Components.Form.{
        CustomMultipleSelectInput,
        CustomTextareaInput,
        CustomMapInput,
        CustomDatePicker,
        CustomTimeInput,
        CustomPasswordInput,
        StarRatingInput,
        UnixInput
      }

      alias AppWeb.Petal.Components.{
        FormField,
        Avatar,
        Container,
        Spinner,
        Button,
        Star,
        Rating,
        Avatar,
        CloudinaryImg,
        ModalAlert,
        Pill,
        DateTimeLocal,
        Dropdown,
        DropdownMenuItem,
        UserContent,
        Navbar,
        Alert,
        Box,
        PageBanner,
        PageHeading,
        LeftSidebarLayout,
        StripeElementsForm,
        Table,
        Code,
        CodeHighlighter,
        DarkThemeSwitch
      }
    end
  end
end
