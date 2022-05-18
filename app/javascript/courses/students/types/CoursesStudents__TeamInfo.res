type student = {
  id: string,
  name: string,
  title: string,
  avatarUrl: option<string>,
  userTags: array<string>,
}

type t = {
  id: string,
  name: string,
  teamTags: array<string>,
  levelId: string,
  students: array<student>,
  coachUserIds: array<string>,
  droppedOutAt: option<Js.Date.t>,
  accessEndsAt: option<Js.Date.t>,
}

let id = t => t.id
let levelId = t => t.levelId

let name = t => t.name

let tags = t => t.teamTags

let title = t => t.title

let students = t => t.students

let coachUserIds = t => t.coachUserIds

let studentId = (student: student) => student.id

let studentName = (student: student) => student.name

let studentTitle = (student: student) => student.title

let studentAvatarUrl = student => student.avatarUrl

let studentTags = (student: student) => student.userTags

let droppedOutAt = t => t.droppedOutAt

let accessEndsAt = t => t.accessEndsAt

let studentWithId = (studentId, t) =>
  t.students |> ArrayUtils.unsafeFind(
    (student: student) => student.id == studentId,
    "Could not find student with ID " ++ (studentId ++ (" in team with ID " ++ t.id)),
  )

let makeStudent = (~id, ~name, ~title, ~avatarUrl, ~userTags) => {
  id: id,
  name: name,
  title: title,
  avatarUrl: avatarUrl,
  userTags: userTags,
}

let make = (
  ~id,
  ~name,
  ~teamTags,
  ~levelId,
  ~students,
  ~coachUserIds,
  ~droppedOutAt,
  ~accessEndsAt,
) => {
  id: id,
  name: name,
  teamTags: teamTags,
  levelId: levelId,
  students: students,
  coachUserIds: coachUserIds,
  droppedOutAt: droppedOutAt,
  accessEndsAt: accessEndsAt,
}

let makeFromJS = teamDetails => {
  let students = Js.Array.map(
    student =>
      makeStudent(
        ~id=student["id"],
        ~name=student["user"]["name"],
        ~title=student["user"]["title"],
        ~avatarUrl=student["user"]["avatarUrl"],
        ~userTags=student["user"]["taggings"],
      ),
    teamDetails["students"],
  )

  make(
    ~id=teamDetails["id"],
    ~name=teamDetails["name"],
    ~teamTags=teamDetails["teamTags"],
    ~levelId=teamDetails["levelId"],
    ~students,
    ~coachUserIds=teamDetails["coachUserIds"],
    ~droppedOutAt=teamDetails["droppedOutAt"]->Belt.Option.map(DateFns.decodeISO),
    ~accessEndsAt=teamDetails["accessEndsAt"]->Belt.Option.map(DateFns.decodeISO),
  )
}

let makeArrayFromJs = detailsOfTeams => Js.Array.map(makeFromJS, detailsOfTeams)

let otherStudents = (studentId, t) =>
  t.students |> Js.Array.filter((student: student) => student.id != studentId)

let coaches = (allTeamCoaches, t) =>
  allTeamCoaches |> Js.Array.filter(teamCoach =>
    t |> coachUserIds |> Array.mem(teamCoach |> UserProxy.userId)
  )
