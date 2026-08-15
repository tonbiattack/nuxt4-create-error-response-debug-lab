import { createError, defineEventHandler, getQuery } from "h3";

type TaskUpdateResponse = {
  id: string;
  title: string;
};

export default defineEventHandler((event): TaskUpdateResponse => {
  const { title } = getQuery(event);

  if (typeof title !== "string" || title.trim().length === 0) {
    throw createError({
      statusCode: 400,
      statusMessage: "Invalid title",
      data: {
        code: "INVALID_TITLE"
      }
    });
  }

  return {
    id: "task-001",
    title: title.trim()
  };
});
