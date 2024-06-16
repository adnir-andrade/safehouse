import { View, StyleSheet } from "react-native";
import React, { useEffect, useState } from "react";
import { useRouter } from "expo-router";
import LoginButton from "../components/LoginButton";
import FullScreen from "../components/containers/Fullscreen";
import Background from "../components/ui/Background";
import Logo from "../components/ui/Logo";
import LoginForm from "../components/LoginForm";

export default function index() {
  const router = useRouter();

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = async () => {
    router.push("/list");
  };

  return (
    <FullScreen>
      <Background>
        <View style={styles.container}>
          <Logo />
          <LoginForm
            username={username}
            password={password}
            setUsername={setUsername}
            setPassword={setPassword}
          />
          <LoginButton onPress={handleLogin} />
        </View>
      </Background>
    </FullScreen>
  );
}

const styles = StyleSheet.create({
  logo: {
    fontSize: 32,
    fontWeight: "bold",
    textAlign: "center",
  },
  container: {
    flex: 1,
    width: "50%",
    justifyContent: "center",
    alignItems: "center",
    alignSelf: "center",
  },
});
