# Unity Version
> Unity 2019.4.24f1
# Documentation
[Mirror Networking](https://mirror-networking.gitbook.io/docs/)
[Parrel-Sync](https://github.com/VeriorPies/ParrelSync)
# Standard pisania kodu
Pamiętaj, że klasa ma służyć tylko do jednej rzeczy. Czyli zasady DRY, KISS, SOLID tutaj obowiązują.

- Prywatne pola klas definujemy w taki sposób

```csharp
    private int _variableExample = 0;
```

- Właściowści klasy są zawsze publiczne i zaczynamy od dużej litery.

```csharp
    public int PropExample {get; set;}
```

- Staramy się dostarczać jak najprostszy interfejs w klasie
- Nazwy interfejsów zaczynamy od literki "I"
- Publiczne enumy definiujemy w specjalnym pliku pod nazwą Enums.cs
- Publiczne argumenty definijemy w specjalnym pliku pod nazwą GlobalEventArgs.cs