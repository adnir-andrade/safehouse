import { Button, View, StyleSheet } from "react-native";
import React, { useState } from "react";
import HeaderWithTitle from "../components/headers/HeaderWithMenu";
import Background from "../components/ui/Background";
import Card from "../components/containers/Card";
import FormInput from "../components/FormInput";
import { useRouter } from "expo-router";

type Survivor = {
  id?: string;
  name: string;
  age: number;
  gender: string;
  is_alive: string;
};

export default function survivorDelete() {
  const [id, setId] = useState("");
  const router = useRouter();

  const handleIdChange = (id: string) => {
    setId(id);
  };

  const handleDelete = async () => {
    router.push("/list");
  };

  return (
    <Background>
      <HeaderWithTitle title="Put it to sleep" />
      <View style={styles.view}>
        <Card>
          <FormInput
            label="ID to Delete"
            placeholder="88"
            placeholderTextColor="#999"
            value={id}
            onChangeText={handleIdChange}
          />
          <Button title="Delete" onPress={handleDelete} />
        </Card>
      </View>
    </Background>
  );
}

const styles = StyleSheet.create({
  list: {
    color: "#fff",
  },
  view: {
    margin: 25,
    paddingHorizontal: 400,
  },
});
