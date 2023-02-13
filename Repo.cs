public class Repo{
    public string full_name { get; set; }
    public string description { get; set; }
    public string GetRepoLink(){
        return "https://github.com/" + full_name;
    }
}