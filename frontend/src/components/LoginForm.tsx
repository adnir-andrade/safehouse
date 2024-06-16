import { View, StyleSheet } from "react-native";
import Card from "../components/containers/Card";
import FormInput from "../components/FormInput";
import React, { SetStateAction } from "react";

type LoginFormProps = {
  username: string;
  password: string;
  setUsername: React.Dispatch<SetStateAction<string>>;
  setPassword: React.Dispatch<SetStateAction<string>>;
};

export default function LoginForm({
  username,
  password,
  setUsername,
  setPassword,
}: LoginFormProps) {
  return (
    <View style={styles.form}>
      <Card>
        <FormInput
          label="USERNAME"
          value={username}
          onChangeText={setUsername}
        />
        <FormInput
          label="PASSWORD"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
      </Card>
    </View>
  );
}

const styles = StyleSheet.create({
  form: {
    paddingTop: 100,
    paddingHorizontal: 40,
  },
});
