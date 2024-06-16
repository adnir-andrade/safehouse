import { View, StyleSheet, FlatList, Text } from "react-native";
import HeaderWithTitle from "../components/headers/HeaderWithMenu";
import Background from "../components/ui/Background";
import Card from "../components/containers/Card";
import { useContext, useEffect, useState } from "react";
import AppContext from "../contexts/AppContext";
import api from "../services/api";

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
        setData(response.data);
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const renderItem = ({ item }: { item: Survivor }) => (
    <View style={styles.container}>
      <Card>
        <Text style={[{ color: app!.textColor }]}>ID: {item.id}</Text>
        <Text style={[{ color: app!.textColor }]}>Name: {item.name}</Text>
        <Text style={[{ color: app!.textColor }]}>Age: {item.age}</Text>
        <Text style={[{ color: app!.textColor }]}>Age: {item.gender}</Text>
        <Text style={[{ color: app!.textColor }]}>Status: {item.is_alive}</Text>
      </Card>
    </View>
  );

  return (
    <Background>
      <HeaderWithTitle title="List" />
      <View style={styles.view}>
        {loading ? (
          <Text style={[{ color: app!.textColor }]}>Loading...</Text>
        ) : (
          <Card>
            <FlatList
              data={data}
              renderItem={renderItem}
              keyExtractor={(item) => item.id?.toString() || item.name}
            />
          </Card>
        )}
      </View>
    </Background>
  );
}

const styles = StyleSheet.create({
  container: {
    marginBottom: 20,
  },
  view: {
    margin: 25,
    paddingHorizontal: 400,
  },
});
