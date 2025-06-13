using System.Reflection;

namespace KrishiSancharDataAccess.Converter;

public abstract class Enumeration : IComparable
{
    protected Enumeration(int id, string name)
    {
        (Id, Name) = (id, name);
    }

    public string Name { get; }
    public int Id { get; }

    public int CompareTo(object other)
    {
        return Id.CompareTo(((Enumeration)other).Id);
    }

    public override string ToString()
    {
        return Name;
    }

    public static IEnumerable<T> GetAll<T>() where T : Enumeration
    {
        return typeof(T).GetFields(BindingFlags.Public |
                                   BindingFlags.Static |
                                   BindingFlags.DeclaredOnly)
            .Select(f => f.GetValue(null))
            .Cast<T>();
    }

    public override bool Equals(object obj)
    {
        if (obj is not Enumeration otherValue) return false;

        var typeMatches = GetType() == obj.GetType();
        var valueMatches = Id.Equals(otherValue.Id);

        return typeMatches && valueMatches;
    }

    public static implicit operator string(Enumeration name)
    {
        return name.ToString();
    }
}