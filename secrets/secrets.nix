let
  pankaj  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7DQVc0xdPzziGOuFRSvgSRNDyYRn2+7s2K86YFmvq7 p.raghav@samsung.com";
  andreas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDoXHJ/4j7kIHmMtLMmqSusvcJpTYUsRp8mZM6QV3HE4 aeh@aeh-pocket";
  daniel  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMImV6kLnytXQt6l1alTWOnOuu9+fvkTyjOyReVNcUx1 Daniel Gomez";
in
{
  "priv_pass.age".publicKeys = [ pankaj andreas daniel ];
}
