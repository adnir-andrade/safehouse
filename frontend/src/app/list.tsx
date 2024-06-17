import { View, StyleSheet, FlatList, Text, Pressable } from "react-native";
import HeaderWithTitle from "../components/headers/HeaderWithMenu";
import Background from "../components/ui/Background";
import Card from "../components/containers/Card";
import { useContext, useEffect, useState } from "react";
import AppContext from "../contexts/AppContext";
import api from "../services/api";
import { ScrollView } from "react-native-gesture-handler";
import { Ionicons } from "@expo/vector-icons";
import { router } from "expo-router";

type Survivor = {
  id?: string;
  name: string;
  age: number;
  gender: string;
  is_alive: string;
};

export default function list() {
  const app = useContext(AppContext);
  const [data, setData] = useState<Survivor[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await api.get("http://10.193.231.210:3000/survivors");
        setData(response.data.survivors);
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const handleEdit = (id:string | undefined) => {
    router.navigate(`/update?id=${id}`)
  }

  return (
    <Background>
      <HeaderWithTitle title="List" />
      <ScrollView contentContainerStyle={styles.scrollView}>
        {loading ? (
          <Text style={[styles.text, { color: app!.textColor }]}>Loading...</Text>
        ) : (
          data.map((item) => (
            <View key={item.id} style={styles.container}>
              <Card>
                <Text style={[styles.text, { color: app!.textColor }]}>ID: {item.id}</Text>
                <Text style={[styles.text, { color: app!.textColor }]}>Name: {item.name}</Text>
                <Text style={[styles.text, { color: app!.textColor }]}>Age: {item.age}</Text>
                <Text style={[styles.text, { color: app!.textColor }]}>Gender: {item.gender}</Text>
                <Text style={[styles.text, { color: app!.textColor }]}>Status: {item.is_alive}</Text>
                <Pressable onPress={() => handleEdit(item.id)}>
                  <Ionicons name="pencil" size={24} color="black" />
                </Pressable>
              </Card>
            </View>
          ))
        )}
      </ScrollView>
    </Background>
  );
}

const styles = StyleSheet.create({
  scrollView: {
    flexGrow: 1,
    justifyContent: "center",
    alignItems: "center",
  },
  container: {
    marginTop: 30,
    marginBottom: 20,
    width: "35%",
  },
  text: {
    fontSize: 16,
    marginVertical: 5,
  },
});
