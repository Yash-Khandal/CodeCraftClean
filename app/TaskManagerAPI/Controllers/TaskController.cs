using Microsoft.AspNetCore.Mvc;
using TaskManagerAPI.Models;

namespace TaskManagerAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TaskController : ControllerBase
    {
        private static readonly List<TaskItem> Tasks = new();

        [HttpGet]
        public ActionResult<IEnumerable<TaskItem>> Get() => Ok(Tasks);

        [HttpPost]
        public ActionResult<TaskItem> Create(TaskItem task)
        {
            task.Id = Tasks.Count + 1;
            Tasks.Add(task);
            return CreatedAtAction(nameof(Get), new { id = task.Id }, task);
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, TaskItem updated)
        {
            var task = Tasks.FirstOrDefault(t => t.Id == id);
            if (task == null) return NotFound();

            task.Title = updated.Title;
            task.IsCompleted = updated.IsCompleted;
            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var task = Tasks.FirstOrDefault(t => t.Id == id);
            if (task == null) return NotFound();

            Tasks.Remove(task);
            return NoContent();
        }
    }
}
