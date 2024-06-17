import { Button, View, StyleSheet, Alert } from "react-native";
import React, { useState } from "react";
import HeaderWithTitle from "../components/headers/HeaderWithMenu";
import Background from "../components/ui/Background";
import Card from "../components/containers/Card";
import FormInput from "../components/FormInput";
import { useRouter } from "expo-router";
import api from "../services/api";

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
    try {
      await api.delete(`http://10.193.231.210:3000/survivors/${id}`);
      Alert.alert("It's dead!", `Survivor with ID ${id} eliminated successfully.`);
      router.push("/list");
    } catch (error) {
      console.error("Error deleting survivor:", error);
      Alert.alert("Delete Failed", "An error occurred while deleting the survivor.");
    }
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
